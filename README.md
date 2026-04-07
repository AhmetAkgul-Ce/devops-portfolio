\---



\# 🚀 DevOps Portfolio - Automated CI/CD Pipeline



AWS EC2 üzerinde çalışan, Terraform ile kurulan, GitHub Actions ile otomatik deploy edilen containerized Node.js uygulaması.



\## 🌐 Canlı Demo

\- \*\*Ana Sayfa:\*\* http://52.57.22.132/

\- \*\*Health Check:\*\* http://52.57.22.132/health



\## ✨ Özellikler

\- ✅ \*\*IaC\*\* - Terraform ile AWS EC2 otomatik kurulum

\- ✅ \*\*Containerization\*\* - Docker ile izole, taşınabilir ortam

\- ✅ \*\*CI/CD\*\* - GitHub Actions ile push → build → deploy otomasyonu

\- ✅ \*\*Monitoring\*\* - Gerçek zamanlı sistem sağlığı \& uptime takibi

\- ✅ \*\*Modern UI\*\* - Responsive, karanlık tema arayüz



\## 🛠 Teknolojiler



| Kategori | Teknoloji |

|----------|-----------|

| \*\*Cloud\*\* | AWS EC2 (t2.micro) |

| \*\*IaC\*\* | Terraform |

| \*\*Container\*\* | Docker |

| \*\*CI/CD\*\* | GitHub Actions |

| \*\*Runtime\*\* | Node.js 20 (Alpine) |

| \*\*Framework\*\* | Express.js |



\## 🏗️ Mimari



&#x20;   \[Developer] → (git push) → \[GitHub]

&#x20;                         ↓

&#x20;             \[GitHub Actions Pipeline]

&#x20;                         ↓

&#x20;      (SSH/SCP) \[AWS EC2 Instance]

&#x20;                         ↓

&#x20;             \[Docker Container → Port 80]



\## 📦 Kurulum



\### 1. Repo'yu Çek

&#x20;   git clone https://github.com/AhmetAkgul-Ce/devops-portfolio.git

&#x20;   cd devops-portfolio



\### 2. Terraform ile Altyapıyı Kur

&#x20;   terraform init

&#x20;   terraform apply -auto-approve



\### 3. GitHub Secrets Ekle



| Secret | Değer |

|--------|-------|

| AWS\_ACCESS\_KEY\_ID | AWS Access Key |

| AWS\_SECRET\_ACCESS\_KEY | AWS Secret Key |

| AWS\_REGION | eu-central-1 |

| EC2\_HOST | EC2 Public IP |

| EC2\_USER | ubuntu |

| EC2\_KEY | .pem dosya içeriği |



\## 🔄 CI/CD Akışı



1\. `main` branch'e push yapılır

2\. GitHub Actions tetiklenir

3\. Dosyalar EC2'ye SCP ile kopyalanır

4\. Docker image rebuild edilir

5\. Eski container durdurulur, yenisi ayağa kalkar

6\. Health check başarılı olursa deployment tamamlanır



\## 📊 Kullanım



&#x20;   # Ana sayfa

&#x20;   curl http://52.57.22.132/



&#x20;   # Health JSON

&#x20;   curl http://52.57.22.132/health



\*\*JSON Response:\*\*



&#x20;   {

&#x20;     "status": "OK",

&#x20;     "timestamp": "2026-04-08T...",

&#x20;     "uptime": "0s 15d 32sn"

&#x20;   }



\## 🔒 Güvenlik \& Maliyet



\- ✅ SSH Key auth, minimal Security Group (80, 22)

\- ✅ IAM Least Privilege, GitHub Secrets yönetimi

\- 💰 \*\*Aylık Maliyet:\*\* \~$8-10 (Free Tier ile ilk yıl ücretsiz)



\---



<div align="center">



\*\*Made by Ahmet Akgül\*\*



\[GitHub](https://github.com/AhmetAkgul-Ce) • \[LinkedIn](https://linkedin.com/in/...)



</div>



\---

